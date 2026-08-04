class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://ghfast.top/https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "2713a890adcbc86c0a4c277e00fcd950f8b4753da331e4306677384c87a24f18"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "70e53d8f4360743ab30eb5c5a672dde86fc91a7d5f06334bbb428b097b7fe51f"
    sha256 cellar: :any, arm64_sequoia: "dc3e4939b88dfc5ec24d430dac38201a87b524423d22c00bb9ba3aa72fc3a382"
    sha256 cellar: :any, arm64_sonoma:  "fd44379592b0ad2eb866773be7500b6d3cf1ba0e1524ac1b643e1d66776171fb"
    sha256 cellar: :any, sonoma:        "143b8e1cf977bef0e751c232f492fd6b1ea0c6f1771b7eaba65732baba61eda3"
    sha256 cellar: :any, arm64_linux:   "8db00144a2a16b5bbec001673256b48a4afa9bfb81bfd7d18f3b0ab03ba58158"
    sha256 cellar: :any, x86_64_linux:  "09373a381e7eb192f1c0e144063200d37079143650b81db831b4b5c1bb70f076"
  end

  depends_on "openssl@3"
  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/rails-mcp-server"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".config/rails-mcp/projects.yml").write <<~YAML
      test: #{testpath}
    YAML

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18"}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{"cursor":null}}
    JSON

    output = pipe_output("#{bin}/rails-mcp-server 2>&1", json, 0)
    assert_match "Change the active Rails project to interact with a different codebase", output
  end
end