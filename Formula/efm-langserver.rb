class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://ghproxy.com/https://github.com/mattn/efm-langserver/archive/v0.0.45.tar.gz"
  sha256 "cdbf7fa804fdc52c5143187194387bd5cf0dcf64a8c611b2393b68397d1e746d"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f231a5618cf0a161de902fb6c5238b09a4cb0190d988bc5687177a7e75b2335"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f231a5618cf0a161de902fb6c5238b09a4cb0190d988bc5687177a7e75b2335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f231a5618cf0a161de902fb6c5238b09a4cb0190d988bc5687177a7e75b2335"
    sha256 cellar: :any_skip_relocation, ventura:        "48fdc5e89094e31cc62e4a3dd357b7b1ad122f4b6144d551b3534891bb43b8c7"
    sha256 cellar: :any_skip_relocation, monterey:       "48fdc5e89094e31cc62e4a3dd357b7b1ad122f4b6144d551b3534891bb43b8c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "48fdc5e89094e31cc62e4a3dd357b7b1ad122f4b6144d551b3534891bb43b8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1972d5afba9be8af2134132690c1f6f29f496152119a89d612a5b1fa8e4a9280"
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