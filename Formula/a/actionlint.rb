class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https:rhysd.github.ioactionlint"
  url "https:github.comrhysdactionlintarchiverefstagsv1.7.6.tar.gz"
  sha256 "59b49d1cabe927d2f1ba67b15f4cd44e56b30ba28eaf48f9bdd71274bedb8061"
  license "MIT"
  revision 1
  head "https:github.comrhysdactionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bd6d76f6e07f1908754e770c907782702154fde31c66651b5296301c9f54947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bd6d76f6e07f1908754e770c907782702154fde31c66651b5296301c9f54947"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bd6d76f6e07f1908754e770c907782702154fde31c66651b5296301c9f54947"
    sha256 cellar: :any_skip_relocation, sonoma:        "b680789b47bba8b2a0438171315072575432c03845e88f083f89a7d31f6a93e2"
    sha256 cellar: :any_skip_relocation, ventura:       "b680789b47bba8b2a0438171315072575432c03845e88f083f89a7d31f6a93e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f300027c75eca3be9900adecb2065a5dcf2f6b349355421d2f258f4d1be5ac"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

  # Support ARM64 runners, upstream pr ref, https:github.comrhysdactionlintpull503
  patch do
    url "https:github.comrhysdactionlintcommit9058a060232e484b6bc958a8f56e908108d1c85c.patch?full_index=1"
    sha256 "4a721ad09d1be86be8210571666625f8dfdf0387fce2b6776bd0e45ef87e24b9"
  end

  def install
    ldflags = "-s -w -X github.comrhysdactionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdactionlint"
    system "ronn", "manactionlint.1.ronn"
    man1.install "manactionlint.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}actionlint --version 2>&1")

    (testpath"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actionscheckout@v4
    YAML

    output = shell_output("#{bin}actionlint #{testpath}action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end