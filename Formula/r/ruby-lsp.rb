class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://ghfast.top/https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "358cd9a377ee9849a27a8f68d3fb3d1977e55ca84a374852971af4b344757efc"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "826a143cfae84facbc47fab86674f1d612f8e6c5a1390b84e43938f0d08c3e07"
    sha256 cellar: :any,                 arm64_sequoia: "718652589f3e800b0b983896ec69ed31cdce239aeb49b421fb092d8122471bc9"
    sha256 cellar: :any,                 arm64_sonoma:  "98bacffb55e86b4d64b17ca643fb7080f55d56d535d790868645cf719bd23c2c"
    sha256 cellar: :any,                 sonoma:        "f49fe294fddad367ae1bab6714ea7414eacdcffdd7faae167ec7d0fc1df6042c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c8a5804b3a1fa48ae7de04a3e1b161d619d90a0d920a209c679aa25e7ac7696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d89d9728ff283f10f9ce1c6f2afd6c4602853ca97d64a00531746709a5bf891a"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files libexec/"bin",
      PATH:     "#{Formula["ruby"].opt_bin}:$PATH",
      GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/ruby-lsp 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end