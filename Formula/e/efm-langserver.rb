class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https:github.commattnefm-langserver"
  url "https:github.commattnefm-langserverarchiverefstagsv0.0.49.tar.gz"
  sha256 "db9ff85f5eba5439f771488434bb9f4fe93e724094189cac3a536539e7ec1e3e"
  license "MIT"
  head "https:github.commattnefm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12d9872df404d4ed9e4ed14f3e9ea941b1466b19c476c5ef8471addac223b5e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12d9872df404d4ed9e4ed14f3e9ea941b1466b19c476c5ef8471addac223b5e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d9872df404d4ed9e4ed14f3e9ea941b1466b19c476c5ef8471addac223b5e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "114076c67e9ceee4e5ac3a6dfef3ec5fc9b9a1ad3f43a03f4a20c97e8771ecf9"
    sha256 cellar: :any_skip_relocation, ventura:        "114076c67e9ceee4e5ac3a6dfef3ec5fc9b9a1ad3f43a03f4a20c97e8771ecf9"
    sha256 cellar: :any_skip_relocation, monterey:       "114076c67e9ceee4e5ac3a6dfef3ec5fc9b9a1ad3f43a03f4a20c97e8771ecf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87d3310758d03e2433b322190595e986d6c3b0de76ccff2b9e30ed8713c52764"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}efm-langserver -c #{testpath"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end