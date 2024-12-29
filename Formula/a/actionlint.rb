class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https:rhysd.github.ioactionlint"
  url "https:github.comrhysdactionlintarchiverefstagsv1.7.5.tar.gz"
  sha256 "ec5bca19701ff27c74f5aca6239d7e8e82a71f42e470a80abce1253bdb1baab5"
  license "MIT"
  head "https:github.comrhysdactionlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb94ee4c428f8e7707eda4443b1813068839541a79eb6acbdfa0986907e9119"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bb94ee4c428f8e7707eda4443b1813068839541a79eb6acbdfa0986907e9119"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6bb94ee4c428f8e7707eda4443b1813068839541a79eb6acbdfa0986907e9119"
    sha256 cellar: :any_skip_relocation, sonoma:        "b172b261e49d8f3329b16accd8713aa3464df5514133e6402723e2e4800f27f7"
    sha256 cellar: :any_skip_relocation, ventura:       "b172b261e49d8f3329b16accd8713aa3464df5514133e6402723e2e4800f27f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efd9318b83817d5e2817c1fc883ac494e49d023e6335373c2248600253109445"
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