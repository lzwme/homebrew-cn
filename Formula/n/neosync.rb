class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.4.94.tar.gz"
  sha256 "9cbb01430d90c6059d5e09249dcfd24f05ede3d0a9200f7101f6dc03acfe3e64"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2682f70ec32d56d24473cd7b1353df57579363d1f317631765eb5617aa821dff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2682f70ec32d56d24473cd7b1353df57579363d1f317631765eb5617aa821dff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2682f70ec32d56d24473cd7b1353df57579363d1f317631765eb5617aa821dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "227f6d44d2ae514c598be2f317d9a8e5b2cac2f27441fe94ae8ecb0883275c79"
    sha256 cellar: :any_skip_relocation, ventura:       "227f6d44d2ae514c598be2f317d9a8e5b2cac2f27441fe94ae8ecb0883275c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999ce71a1cbefdcbba1a2cdb9d6b79e75f293afb7f31294e49fd96f6bcf77882"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".clicmdneosync"

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end