class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://ghfast.top/https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "1acdd825114795b5852a0c2b6ab8b2558fb7d23e085af3a8fc86398011a9efa9"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e5ec10a80c590e3c9877a4e8da38b57f47319618cf80afb0451651a8a1b6721"
    sha256 cellar: :any,                 arm64_sequoia: "e92d254f3cea0c6ba9ce4cee80854153452a69eae66857072e269e3ad98230d3"
    sha256 cellar: :any,                 arm64_sonoma:  "c8f91be5ea5b9116576ea3f9dcfdadce7d0c714ad044f6c8c23328f7a3c3007b"
    sha256 cellar: :any,                 sonoma:        "2fe2d5778b3d81ec3f29ff849aca428b52761cb40ec58b876c329258b9fda042"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fa3480c87ad2b766ab1e59f8cc27202e1163a514392ec8cbd67034b98b2b4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e98ca4812ec14b288def0f42b7af8f098b40a51ea90397e7d85aebfebf8a8b0"
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