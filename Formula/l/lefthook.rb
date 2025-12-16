class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.12.tar.gz"
  sha256 "c4db36b835e2f656eb888461c1454d32adf85ad774fc609a99cb77365b9d1e0c"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da8ecbff6a467f4978060e7150f14707a7e752a24a4e9d7a19188b42b119729c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da8ecbff6a467f4978060e7150f14707a7e752a24a4e9d7a19188b42b119729c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da8ecbff6a467f4978060e7150f14707a7e752a24a4e9d7a19188b42b119729c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8607dbac16b0e6cb63928b21812f723fd7b5f5e8371a21feb7fcf62abc26e26e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eb91677a17498dcb935f783246b70d7a7d73c4ba3ebccd8a0e6aaa23ad894bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "507c889a545a264a484474cf1c0ff7bdbf6df794bb6c3f7a8a853d03d1d63777"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end