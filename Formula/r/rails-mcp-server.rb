class RailsMcpServer < Formula
  desc "MCP server for Rails applications"
  homepage "https://github.com/maquina-app/rails-mcp-server"
  url "https://ghfast.top/https://github.com/maquina-app/rails-mcp-server/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "679f894c2fce87eb56f29cef9332edde9aafe87fb4aa0587a3f65cd96c112395"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a035b879c8340fe514b53020e87d5c56badc0818025349f0d2d5f78806daf61"
    sha256 cellar: :any,                 arm64_sequoia: "d5e9d141cb526b10b92bc650e8612807e1a197535f9404af8989ebeffd2f94df"
    sha256 cellar: :any,                 arm64_sonoma:  "da4dc96f326399108a10cefb7b892fe5dddbced6c4986ebce80416b048fc1701"
    sha256 cellar: :any,                 sonoma:        "c20ed88da80953c89f1e851365ff6ba8bfa375047b633ade123b32e8e7d8ac1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42603401417642b6f5079f519c6ed4a20e3ea67a47aa0f8007caacca14e934b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a64bb245bd7fa8ebcfda6117c55a03001bd27c67bc054d62c0f9d0be3c5afe"
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