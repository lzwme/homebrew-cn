class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https:rhysd.github.ioactionlint"
  url "https:github.comrhysdactionlintarchiverefstagsv1.7.4.tar.gz"
  sha256 "3004bcb4615510e671c76a56259755ed616c3200fb73b0be0ca9c3d6ea09c73a"
  license "MIT"
  head "https:github.comrhysdactionlint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1daf27858f22af83e9d0e4a9dca987c91a75750a3abcbd52896a30694fc3182f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1daf27858f22af83e9d0e4a9dca987c91a75750a3abcbd52896a30694fc3182f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1daf27858f22af83e9d0e4a9dca987c91a75750a3abcbd52896a30694fc3182f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab63732f13a54479ccddc895934a38bf94f7a150c04dd62e41c2830d05ea50de"
    sha256 cellar: :any_skip_relocation, ventura:       "ab63732f13a54479ccddc895934a38bf94f7a150c04dd62e41c2830d05ea50de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6922639d4cede7b462b08e28ef0d7dce4f3163e8d82ef9cadfa0d430576ed4"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build
  depends_on "shellcheck"

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