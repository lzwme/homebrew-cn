class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://ghfast.top/https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.7.tar.gz"
  sha256 "e0eccbb6101884e4010083ad93fb0ca726911f73da6d2c1ce367c53b04969096"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "377d05d7efe1ac175a4301f21ff9428ec5311963a35d8e605454f028ededd67e"
    sha256 cellar: :any,                 arm64_sequoia: "18e494d806c8ae3aa19bac525cd80a7933cdb0753f77a9ff5f0ee642489512de"
    sha256 cellar: :any,                 arm64_sonoma:  "6ef73481c225bee5133e2c09e08940f6db6cff6ca68330a59d977924c5200acb"
    sha256 cellar: :any,                 sonoma:        "b6e09dfa92d3870b25bd6d4178e0e26943b40258d2cfd2d8cbe17e8ac51d6a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14e204505db52a23fb83638186caf9a0d6098b6deb74df12a1bf718262e58ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e2794bf62c1085ef383e180364f7bab430c63b52e3a90f3e94ee631f89307e"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

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