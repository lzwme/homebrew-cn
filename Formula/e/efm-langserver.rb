class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https:github.commattnefm-langserver"
  url "https:github.commattnefm-langserverarchiverefstagsv0.0.54.tar.gz"
  sha256 "4149b2922899ce313a89f60851f6678369253ed542dd65bdc8dd22f3cf1629bb"
  license "MIT"
  head "https:github.commattnefm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf0b828b6d451c479718b4e1d59fb702b6b213e23de81472ceccd4af4c30f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf0b828b6d451c479718b4e1d59fb702b6b213e23de81472ceccd4af4c30f56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cf0b828b6d451c479718b4e1d59fb702b6b213e23de81472ceccd4af4c30f56"
    sha256 cellar: :any_skip_relocation, sonoma:        "89928fa34e9f83ed16f3a69e36b7a01bb2566a2c9a56c14bbd486f553641ce97"
    sha256 cellar: :any_skip_relocation, ventura:       "89928fa34e9f83ed16f3a69e36b7a01bb2566a2c9a56c14bbd486f553641ce97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c26b74e7b23809dab23791a2366f8ab2720a07dc35b7759d67f391303daa3d3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath"config.yml").write <<~YAML
      version: 2
      root-markers:
        - ".git"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    YAML
    output = shell_output("#{bin}efm-langserver -c #{testpath"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end