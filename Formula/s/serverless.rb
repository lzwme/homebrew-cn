class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https:www.serverless.com"
  url "https:github.comserverlessserverlessarchiverefstagsv3.40.0.tar.gz"
  sha256 "c8058ec43e1e5de67a4a1ee95f0bcec24a4b0ffd4e953b4214961ef7ff2b385d"
  license "MIT"
  head "https:github.comserverlessserverless.git", branch: "v3"

  livecheck do
    url :stable
    regex(^v?(3(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a1d77422f266cc1d32de082fd88653ff2acba640e4369391749f8308232abf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e5580e7acdb2b5a7c4c941d321aac21ccc370b40b8432ff0372b83a33227ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06a1d77422f266cc1d32de082fd88653ff2acba640e4369391749f8308232abf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b64fa8af7e98666d443ca3e0df89433fc4613e1c6c4a1e677139f4e9091f8a2d"
    sha256 cellar: :any_skip_relocation, ventura:       "b64fa8af7e98666d443ca3e0df89433fc4613e1c6c4a1e677139f4e9091f8a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a1d77422f266cc1d32de082fd88653ff2acba640e4369391749f8308232abf"
  end

  # v3 will be maintained through 2024
  # Ref: https:www.serverless.comframeworkdocsguidesupgrading-v4#license-changes
  deprecate! date: "2024-12-31", because: "uses proprietary licensed software in v4"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec"libnode_modulesserverlessnode_modules@serverlessdashboard-plugin")
      .glob("sdk-pyserverless_sdkvendorwrapt_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")
  end

  test do
    (testpath"serverless.yml").write <<~YAML
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    YAML

    system bin"serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx"
    output = shell_output("#{bin}serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end