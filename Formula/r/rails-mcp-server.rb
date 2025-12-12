class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://ghfast.top/https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "aef71b34cb41b4dbcd93d97f8e750d4f2fd15e74fb03c363dbceba22d6d5fa52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6463d51cc5b0db9b326569342cee4d6aea9c9268cd0b353a0cd2b06ac2d254a"
    sha256 cellar: :any,                 arm64_sequoia: "40c7b7c44b4ac3af2d3159665d8af7a2efbbd143f6a93e3ced278f327f9d62c5"
    sha256 cellar: :any,                 arm64_sonoma:  "e009e8da2ba9ac9318e45df214d0049cbaf856635ee5acce9a4a612c25437c4b"
    sha256 cellar: :any,                 sonoma:        "6a5277bd9f7b6e45317a06c0489bcdc6d9c332558d21dcff22a924280e580a40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254e5dcbf6f694d3ef29c4f3a3bc2b9bf6256d25a379b9f8fefdeb70bbf2616e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a5ae6520989d1d4638742a51a3c04e97d1637853b9915b9bb6a24eab9dad84"
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
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/rails-mcp-server"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/".config/rails-mcp/projects.yml").write <<~YAML
      projects:
        - name: test
          path: #{testpath}
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