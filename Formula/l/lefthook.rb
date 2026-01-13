class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://ghfast.top/https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.14.tar.gz"
  sha256 "c2c88c2ff004510acfe511173eaffa51d263d3236b484cce336bf804ddb1f841"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbfed78d7de4126ddc5ce836db62509bcfbc5272726de72da79038c1b294ec1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbfed78d7de4126ddc5ce836db62509bcfbc5272726de72da79038c1b294ec1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbfed78d7de4126ddc5ce836db62509bcfbc5272726de72da79038c1b294ec1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac356ded9be3a7577027bf9e173ff16a08fd1df05c24fad9fa2647fb8417b119"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8043ddd899bfcabc23e87eff2ac12bbfd642afe48b19683ef7895e50f1c3c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b81c1ca0ccef6a905c82950d23d06f8240ca06287bf47508961f8772fd784d96"
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