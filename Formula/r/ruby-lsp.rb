class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https://shopify.github.io/ruby-lsp"
  url "https://ghfast.top/https://github.com/Shopify/ruby-lsp/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "5e0ab4f3b1f03782fc9f5b199913f656f51bf2accab102622fbcf39261b3266e"
  license "MIT"
  head "https://github.com/Shopify/ruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aaa8bd49b3ecbc9d86e16ffbe6c8c300ef26fc17e94a861eba341b7f1a5c9dde"
    sha256 cellar: :any,                 arm64_sequoia: "e062d564cf1f1f535999888ca7b098487a9357bbe4fe011459f588640269c19b"
    sha256 cellar: :any,                 arm64_sonoma:  "09eedecd8512083b14515ce42bbca65424f905d2206e5d069e9243711807a029"
    sha256 cellar: :any,                 sonoma:        "6398ac0fab4fc6cf866372f2c8a58d0462203b51e2e5f8ec2b8ba4723d6a9eee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb06e887494a9f599a75e2c12f8e440799f5103bf54052d6ae2fdf5cb011aff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e184809509e4adb3ddea6f736b13d07b27a3b318454221701d744210b8bc5a9"
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