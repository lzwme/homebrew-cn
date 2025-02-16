class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.32.5.tar.gz"
  sha256 "518150a406469a8610297058a857d8118c2015be3c0693e50b781511dceef924"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2641ea921d4e6e876b4dd40b8353ee93dfc1122469270d7254c62bfc51f44f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28688baa7782504303f418f03db7207fe25353abb0ea1fa225a2b03a35e0c1a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41735e0d67fee8c7880645d6d1c15353d7dee5e1bc8bf00db2bfe1bd3f249e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f412d865a7bb82f0c7c3c035fe274e1e0dd767a2cc604626f29dcdd3951a16bd"
    sha256 cellar: :any_skip_relocation, ventura:       "7af3bba2bf46e4f550fb119454d462f1bdc68cd31163f2d083e31c5888be4e99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9f15a1b4053e570ea8694a03ffe931b7e843aa1b668fade58fd8fea85cf29f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, MOON_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"moon", "init", "--minimal", "--yes"
    assert_path_exists testpath".moonworkspace.yml"
  end
end