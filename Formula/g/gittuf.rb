class Gittuf < Formula
  desc "Security layer for Git repositories"
  homepage "https://gittuf.dev/"
  url "https://ghfast.top/https://github.com/gittuf/gittuf/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7411dbcf69122633e3ee140e76fead29abf7cd5e688a8481bfe20520965c34be"
  license "Apache-2.0"
  head "https://github.com/gittuf/gittuf.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0a80e6ce9d0bb5776c04024d668f0c9418320dce34e46ba985ebb730e20432a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a80e6ce9d0bb5776c04024d668f0c9418320dce34e46ba985ebb730e20432a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a80e6ce9d0bb5776c04024d668f0c9418320dce34e46ba985ebb730e20432a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1cc90f324aab34351f3e8178dc87e3d8a7d66d5f7e9d1ebb0ae04572f4b50fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e33ed1fc3d70cb84a096f8a8600747f47b09e99eb91a9e2515f5bf8ff4643d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c78aa22deb7972af20909b88a7bf55d16bde2d290b41ce1c4fbed01cf7a1c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/gittuf/gittuf/internal/version.gitVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gittuf", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/gittuf policy init 2>&1", 1)
    assert_match "Error: required flag \"signing-key\" not set", output unless OS.linux?

    output = shell_output("#{bin}/gittuf sync 2>&1", 1)
    assert_match "Error: unable to identify git directory for repository", output

    assert_match version.to_s, shell_output("#{bin}/gittuf version")
  end
end