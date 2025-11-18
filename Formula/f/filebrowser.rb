class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.48.1.tar.gz"
  sha256 "556b8092c69b65c11d917c8d1e0fef418ea88a9d437c2ec7b1cab506973eb743"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7975be0517e1185eb7f8f830092419d2d638e83274444bcdb3e74660c89656c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6c3721f3a7c203c799bda4b28118c4b40842d1a8e729fee5e507e25589e293"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f124f96f1308818a6bd8488977a2540713719d395e6a7b2983e3d9482a92590f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c279fa6a9ea2cebafc2d9b73505367896433f88afa2c393900e19998ef199e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e508017324a14c10590b4fa3abea59d723b05032ea5ba83ffd3329724af8ae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4a2c71ad2b6835090c0488fdabb58515e018cbffd6c1163a3a6539b1b87d8c7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end