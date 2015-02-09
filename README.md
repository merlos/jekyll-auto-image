# jekyll-auto-image plugin

jekyll plugin that makes available the first image of a post in the template as a variable.

This plugin is useful if you want to:

*  list the posts of your jekyll site including an image 
*  setting the twitter card image 

# Install

Copy `auto-image.rb` into your jekyll `_plugins` directory


# Usage

In each post/page, the plugin will set `{{ page.image }}` following this fallback rules:

1. Front matter `image` value
2. First image in the post/page contents
3. Default site image (defined in `_config.yml`)
4. Nothing (false)

Basically, the plugin will return the front matter image value if set. If it is not set, then it will look for the first image asset that is defined in your post content. If the post does not have any image, then it will set the site.image defined in _config.yml.

To set the default image for all pages/posts, add to the  `_config.yml` file the following line:

```yaml
 # _config.yml

 image: /path/to/your/default/image.png
```

### Example of usage

Example post 1:

```markdown
---
layout: post
title: Post 1
---

This is my example post

![first image](/assets/first_image.png)

```
Example post 2:

```markdown
---
layout: post
title: Post 2
image: /assets/front_matter_image.png
---

This is my example post

![first image](/assets/first_image.png)

```

Template:

```liquid
{% for post in site.posts %}
title: {{ post.title }}
<br>
image: {{ post.image }}
<hr>
```

HTML output:

```html
title: Post 1
<br>
image: /assets/first_image.png
<hr>

title: Post 2
<br>
image: /assets/front_matter_image.png
```
### Example using twitter cards

You can define a set of `<meta>` elements in your head.html, so when sharing a post in twitter it is displayed in a cool way. You have more info in [twitter's developers page](https://dev.twitter.com/cards/types)

```html
 <!-- twitter card -->
  <meta name="twitter:card" content="{% if page.image %}summary_large_image{% else %}summary{% endif %}">
  <meta name="twitter:site" content="@{{ site.twitter_username }}">
  <meta name="twitter:creator" content="@{{ site.twitter_username }}">
  <meta name="twitter:title" content="{% if page.title %}{{ page.title }}{% else %}{{ site.title }}{% endif %}">
  <meta name="twitter:description" content="{% if page.excerpt %}{{ page.excerpt | strip_html | strip_newlines | truncate: 200 }}{% else %}{{ site.description }}{% endif %}">
{% if page.image %}
  <meta name="twitter:image:src" content="{{ page.image | prepend: site.baseurl | prepend: site.url }}"> 
{% endif %} 
  <!-- end twitter card -->
```  

You can validate how it will look using the [cards validator](https://cards-dev.twitter.com/validator)

# To Do List

 * Make the plugin a gem, so it can be installed using `gem install`
 * add tests cases

# Contributing

1. Fork it (https://github.com/merlos/jekyll-auto-image/fork)
2. Create your feature branch (`git checkout -b my-new-feature)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (git push origin my-new-feature)
4. Create a new Pull Request


# License

Copyright (c) 2015 Juan M. Merlos. (@merlos) Distributed under MIT License

[www.merlos.org](http://www.merlos.org)