class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https:rhysd.github.ioactionlint"
  url "https:github.comrhysdactionlintarchiverefstagsv1.7.2.tar.gz"
  sha256 "df74bf4789cbb9c631b92da5d27ed1f3565fea0f7bb62bb5840c2b99ea999f57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd091f0094698ab4a70c59bb1decda06233774d18033eadf3f78e6a58da18911"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd091f0094698ab4a70c59bb1decda06233774d18033eadf3f78e6a58da18911"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd091f0094698ab4a70c59bb1decda06233774d18033eadf3f78e6a58da18911"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a28ffb80b98a3b5803cfe5566a5b1869225acdfd4421109df4fc374b2d9585"
    sha256 cellar: :any_skip_relocation, ventura:       "67a28ffb80b98a3b5803cfe5566a5b1869225acdfd4421109df4fc374b2d9585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c930ff0b3243018f7ef51dbc33eef22ab3fb1b584917f4303e1722f1d248eca"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    ldflags = "-s -w -X github.comrhysdactionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdactionlint"
    system "ronn", "manactionlint.1.ronn"
    man1.install "manactionlint.1"
  end

  test do
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