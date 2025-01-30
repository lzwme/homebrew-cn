class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https:gauge.org"
  url "https:github.comgetgaugegaugearchiverefstagsv1.6.12.tar.gz"
  sha256 "65cdf9a0aae28d9f64a42737b2a9c47b4c09d05b12f2b78fec65276a26391c6b"
  license "Apache-2.0"
  head "https:github.comgetgaugegauge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4440206310fc9b44973983083ca068e96ab85bfb2b2b93b8a28c3a82571ac87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f9e68faa53d4578172353ceaffbeb7e111867870323f30c7be7788c15808c59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdfd3a14d530c7e37529ada331d490c69f6d9b6b62f14a5a997ccfb17de07eb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c77c9fd76f76a3c317d4e98e9a55d70ddb3d51b6a5c8164718cfdf6fba4f9acb"
    sha256 cellar: :any_skip_relocation, ventura:       "7e9844ad4e9641381525c53bc5ca002e6f7ce6bc1764da1df838e552f6f3cb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33f3931283ff90bbe90154d69a9239aec4edbc3709c58f8e1f7c9a803f80b67"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "buildmake.go"
    system "go", "run", "buildmake.go", "--install", "--prefix", prefix
  end

  test do
    (testpath"manifest.json").write <<~JSON
      {
        "Plugins": [
          "html-report"
        ]
      }
    JSON

    system(bin"gauge", "install")
    assert_predicate testpath".gaugeplugins", :exist?

    system(bin"gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}gauge -v 2>&1")
  end
end