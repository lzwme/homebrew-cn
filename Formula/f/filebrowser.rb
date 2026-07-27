class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.21.tar.gz"
  sha256 "d936b7da78f0aaf987ff195a2dd4159a1f4ffaf85df83876d5243336e1790081"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2202ae96d0c449d5ec3cf0f9e43040fd0f963ff8311eb2f6999ef80b685e754"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c107a05c0120709fff48f3d558c2581e33248462648e394da2f909e3b0f16a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "906d74e428f0ad5fc3a16a006f14ca954a3c28e5f38d7a4d6e8a27a1fd5d1eef"
    sha256 cellar: :any_skip_relocation, sonoma:        "0050425845d8ca2512645e936e7f4265682772afc6d969f1817f050e2b87289c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5dfa8ba4d0ea28b7429bb66916f6de37058d7fcf3d66ec2bde9d12fc99c5187"
    sha256 cellar: :any,                 x86_64_linux:  "abde444f8b521e558002c1b586772ecb500379357e64ed5b928bb7e76cd8c593"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end