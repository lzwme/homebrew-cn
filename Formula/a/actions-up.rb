class ActionsUp < Formula
  desc "Tool to update GitHub Actions to latest versions with SHA pinning"
  homepage "https://github.com/azat-io/actions-up"
  url "https://registry.npmjs.org/actions-up/-/actions-up-1.11.0.tgz"
  sha256 "2c37877e8166a3862268791424548e5c69c6c026e5b12159427601eb5dde0de4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98496bd7b8d8156c0d02a6c08d894653032c64035d5d547111e5a52bb3387d30"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actions-up --version")

    test_file = testpath/".github/workflows/action.yml"
    test_file.write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    assert_match "Updates applied successfully!", shell_output("#{bin}/actions-up --yes")

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, test_file.read)
  end
end