class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://ghproxy.com/https://github.com/mattn/efm-langserver/archive/v0.0.46.tar.gz"
  sha256 "ef81abeadecdde755a80ad34ed089c5bd42bd84b82886666fc699dfb3ec03115"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ec0537aa10ba6c3e77994a30f4c1bf7592ca3bf640a501f2a5bed73d1be481"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ec0537aa10ba6c3e77994a30f4c1bf7592ca3bf640a501f2a5bed73d1be481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69ec0537aa10ba6c3e77994a30f4c1bf7592ca3bf640a501f2a5bed73d1be481"
    sha256 cellar: :any_skip_relocation, ventura:        "eb747e872de24e8f3fcaa40fe1c9c37d714016a389f60fa359c8b6cb4b98fd1e"
    sha256 cellar: :any_skip_relocation, monterey:       "eb747e872de24e8f3fcaa40fe1c9c37d714016a389f60fa359c8b6cb4b98fd1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb747e872de24e8f3fcaa40fe1c9c37d714016a389f60fa359c8b6cb4b98fd1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5449b4d114cef2b58fceefae5fc63f1ca3aeef73203ce145a977a9a856790fd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end