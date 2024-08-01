class GrammarlyLanguageserver < Formula
  desc "Language Server for Grammarly"
  homepage "https:github.comznckgrammarly"
  url "https:registry.npmjs.orggrammarly-languageserver-grammarly-languageserver-0.0.4.tgz"
  sha256 "0d50b88059b5a63c66e3973e94d4f368366087ef59427003106a99bb46c46728"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b88bbd69c207d41bb1ead5ffba2879ed2961c4cbd4147536b80e83aaf821b952"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b88bbd69c207d41bb1ead5ffba2879ed2961c4cbd4147536b80e83aaf821b952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b88bbd69c207d41bb1ead5ffba2879ed2961c4cbd4147536b80e83aaf821b952"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a70d983e2f36b026141bad92136e0532a262aa072bdfde0f50a40ce54fae22e"
    sha256 cellar: :any_skip_relocation, ventura:        "0a70d983e2f36b026141bad92136e0532a262aa072bdfde0f50a40ce54fae22e"
    sha256 cellar: :any_skip_relocation, monterey:       "b88bbd69c207d41bb1ead5ffba2879ed2961c4cbd4147536b80e83aaf821b952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8c0beaa0099184da7a6376055ba6a188e9cebd0d0471af86e65218d0048235"
  end

  deprecate! date: "2023-11-02", because: "uses deprecated `node@16`"

  depends_on "node@16" # try `node` after https:github.comznckgrammarlyissues334

  def install
    system "npm", "install", *std_npm_args
    (bin"grammarly-languageserver").write <<~EOS
      #! usrbinenv sh

      #{Formula["node@16"].bin}node #{libexec}bingrammarly-languageserver "$@"
    EOS
  end

  test do
    require "open3"
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
    Open3.popen3("#{bin}grammarly-languageserver --stdio") do |stdin, stdout, _, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end