class Joker < Formula
  desc "Small Clojure interpreter, linter and formatter"
  homepage "https:joker-lang.org"
  url "https:github.comcandid82jokerarchiverefstagsv1.3.3.tar.gz"
  sha256 "d508e74e781f9b17371773f7d435312d168c854d624f7098e9f0d2ce7cf82be4"
  license "EPL-1.0"
  head "https:github.comcandid82joker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "738c22a3f60329b4a959e509edc96b9e78bf1353e09d98fc6300cd1c0d5c9aeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "729e5151e3de0b0c9292438b3f3f9e5eecf0e65525bc4bda46adca7ee4078249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "378aa13cf7bcd96c5de97943735ce2dd6df70ade34afd81b7f5fc6afea28ebaa"
    sha256 cellar: :any_skip_relocation, sonoma:         "6668f0f4917dd0a130455bb37ea6991147ac7b4e25f97693ef2a7f289fbaf7b6"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0aa839a0d3b0fa1b9a15565556f2f537b65b55981d092eb9ff3e4e16ed8b91"
    sha256 cellar: :any_skip_relocation, monterey:       "b74764b9851887b7da6b96a0330b7c4bb356756105236d7235b817c5382e0cc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0dd421ef0b09d01832fae96959360e86b0eafeba33d41c6f1338e85abcedd0"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "...."
    system "go", "build", *std_go_args
  end

  test do
    test_file = testpath"test.clj"
    test_file.write <<~EOS
      (ns brewtest)
      (defn -main [& args]
        (let [a 1]))
    EOS

    system bin"joker", "--format", test_file
    output = shell_output("#{bin}joker --lint #{test_file} 2>&1", 1)
    assert_match "Parse warning: let form with empty body", output
    assert_match "Parse warning: unused binding: a", output

    assert_match version.to_s, shell_output("#{bin}joker -v 2>&1")
  end
end