class Mage < Formula
  desc "Makerake-like build tool using Go"
  homepage "https:magefile.org"
  url "https:github.commagefilemage.git",
      tag:      "v1.15.0",
      revision: "9e91a03eaa438d0d077aca5654c7757141536a60"
  license "Apache-2.0"
  head "https:github.commagefilemage.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b81db54414e8059c020d3f75144337f216536a73742263d0efe306fcdbd1e140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b81db54414e8059c020d3f75144337f216536a73742263d0efe306fcdbd1e140"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b81db54414e8059c020d3f75144337f216536a73742263d0efe306fcdbd1e140"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3ab340917962784ac8e7dd0e54112f6d60f7546de91aeb8373ba29c80cec26"
    sha256 cellar: :any_skip_relocation, ventura:       "9f3ab340917962784ac8e7dd0e54112f6d60f7546de91aeb8373ba29c80cec26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4f7a29602cc18739d9c7714860f36a3a6c1f12d2e8d6cd3b04b9a0f28ba25e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3721ad24ae36b353b46e1b3fc9b6bc6abf3bc328102da949fe50441e4eebfe5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.commagefilemagemage.timestamp=#{time.iso8601}
      -X github.commagefilemagemage.commitHash=#{Utils.git_short_head}
      -X github.commagefilemagemage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}mage -init 2>&1")
    assert_path_exists testpath"magefile.go"
  end
end