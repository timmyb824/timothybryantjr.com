---
title: "My ZSH Dev Setup"
date: "17:32 03/25/2025"
taxonomy:
  category:
    - blog
  tag:
    - zsh
    - chezmoi
    - oh-my-zsh
    - terminal
hero_classes: "text-dark title-h1h2 overlay-light hero-large parallax"
hero_image: zsh.png
blog_url: /blog
show_sidebar: false
show_breadcrumbs: true
show_pagination: true
---

## My ZSH Dev Setup

As a technologist who values both efficiency and customization, I've evolved my ZSH setup from using Oh-My-Zsh to a more streamlined, modular configuration. While Oh-My-Zsh is fantastic for beginners, I found it somewhat bloated and occasionally slow. This post details my current setup, which prioritizes speed, maintainability, and cross-platform compatibility.

### The Foundation: A Modular Approach

My `.zshrc` is intentionally minimal, serving primarily as an orchestrator that sources various specialized configuration files:

```zsh
# Source initialization settings
source "$HOME/.config/zsh/init.zsh"

# Source the alias file
precmd() {
    source "$HOME/.config/zsh/alias.zsh"
    source "$HOME/.config/zsh/special_alias.zsh"
}

# Source the plugin manager
source "$HOME/.config/zsh/plugin_manager.zsh"

# Source the functions file
source "$HOME/.config/zsh/functions.zsh"

# Set environment variables
source "$HOME/.config/zsh/env.zsh"

# Setup completions
source "$HOME/.config/zsh/completions.zsh"

# Load plugins and package managers
source "$HOME/.config/zsh/packages.zsh"
```

This modular structure offers several benefits:

1. **Maintainability**: Each file has a single responsibility

2. **Organization**: Configurations are logically grouped

3. **Version Control**: Easier to track changes in smaller, focused files

4. **Cross-platform Compatibility**: Using Chezmoi with Go templating for managing dotfiles across Darwin and Linux

### Custom Plugin Management

Instead of relying on Oh-My-Zsh's plugin system, I've implemented a lightweight plugin manager inspired by [zsh_unplugged](https://github.com/mattmc3/zsh_unplugged). My implementation provides:

- Efficient plugin loading with minimal overhead

- Simple plugin management commands

- Conditional loading based on terminal emulator (special handling for terminals such as Warp)

- Support for lazy loading using `zsh-defer`

Here's a glimpse of some key plugins I use:

```zsh
plugins=(
    mdumitru/git-aliases
    agpenton/1password-zsh-plugin
    sparsick/ansible-zsh
    Tarrasch/zsh-bd
    ChrisPenner/copy-pasta
    reegnz/jq-zsh-plugin
    hlissner/zsh-autopair
    MichaelAquilina/zsh-you-should-use
    supercrabtree/k
    romkatv/zsh-defer
)
```

### Terminal-Aware Configuration

My setup is smart enough to adapt based on the terminal emulator in use. For instance, when using Warp terminal, certain plugins are excluded to avoid conflicts and maintain optimal performance:

```zsh
warp_exclusive_plugins=(
    Aloxaf/fzf-tab
    zdharma/fast-syntax-highlighting
    clarketm/zsh-completions
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
)
```

### Dotfile Management with Chezmoi

To maintain consistency across different environments, I use [Chezmoi](https://www.chezmoi.io/) for dotfile management. This allows me to:

- Use Go templating for platform-specific configurations

- Maintain a single source of truth for all my dotfiles

- Easily sync configurations across multiple machines

- Handle sensitive information securely

### Initialization and Shell Integration

My `init.zsh` handles core shell setup and integrations:

- Homebrew initialization

- Completion system setup

- Terminal-specific configurations (Starship prompt, iTerm2 integration)

- Shell history management with Atuin

### Conclusion

This setup strikes a balance between functionality and performance. By breaking down configurations into logical modules and leveraging modern tools like Chezmoi, I've created a development environment that's both powerful and maintainable. The custom plugin manager keeps things lean while still providing the extensibility I need.

Feel free to explore my dotfiles and adapt this setup to your needs. Remember, the best shell configuration is the one that works for your specific workflow!
