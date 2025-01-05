class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https:rhysd.github.ioactionlint"
  url "https:github.comrhysdactionlintarchiverefstagsv1.7.6.tar.gz"
  sha256 "59b49d1cabe927d2f1ba67b15f4cd44e56b30ba28eaf48f9bdd71274bedb8061"
  license "MIT"
  head "https:github.comrhysdactionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e665177b2fffd5665cf190c2edc6bef2782e9e3782ff0cadb6002fb0541f6705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e665177b2fffd5665cf190c2edc6bef2782e9e3782ff0cadb6002fb0541f6705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e665177b2fffd5665cf190c2edc6bef2782e9e3782ff0cadb6002fb0541f6705"
    sha256 cellar: :any_skip_relocation, sonoma:        "82a237d075bb2ebbbe4d0a66df413ad136ac040330a94ba0b129668a0148837a"
    sha256 cellar: :any_skip_relocation, ventura:       "82a237d075bb2ebbbe4d0a66df413ad136ac040330a94ba0b129668a0148837a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc5640f5e494d05d9a3d22f36ad5eb1131a8bdb11a6762150e95c4820395b23"
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