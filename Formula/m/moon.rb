class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https:moonrepo.devmoon"
  url "https:github.commoonrepomoonarchiverefstagsv1.37.3.tar.gz"
  sha256 "d6007ebf5d5bd5d289dda839f185a1d736c0ae8a98de93323db17a1cb878a0f8"
  license "MIT"
  head "https:github.commoonrepomoon.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de334030263b6e4162d0be59b387318650878095c0ca9992c23ae19990df9a9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9671fba10c5070352d68e75aac8ae9364cbc41709268dd8708ae33b9e0d3f129"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2142272e1b02927cf6ded3729197e59aefe053e050be5545d02cbf8686209d0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8e874862d6a13f48c3bf92fb0db267140b354d9f9bbe4f46cf60428dfd34540"
    sha256 cellar: :any_skip_relocation, ventura:       "c68df6575d1d2a971b9c52bca356ed7773b43ad44d3d321f02e2bd6efe05f1f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81fad2c14bb9bc373537e92316298b20a0259f53df7855a68c67dfdd7780a960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fb723ce255d1bfc9279e55e424f3b55beb08a0d37ed4d2f136835f0d5fb51dc"
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