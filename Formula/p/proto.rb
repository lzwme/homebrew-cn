class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.40.2.tar.gz"
  sha256 "a83842771b90273e7c0e53b6acb7e6f4e4824c9789a982684ee4da79f4facfa0"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acc61cf2015b7ee9a28467116ed1c5d12350816dc3e52e97f5f6531b12c86c32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93ca4a92d387182ac518d8178967f4db0eba70009eb2b6804d0418bb10ac965f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a83cc8b4c379a721c5f97f29c80d2f24f11163948b50b2ac8e2b44a0c6b53fb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "40cbbcccc68b71f59663551a85142747fc3721edd11ade15d5ac4a5545bd9c85"
    sha256 cellar: :any_skip_relocation, ventura:        "cc4c7c35d80f93144c7b6566b375aa82f171986e767d3d3cbd6831c4deff63b2"
    sha256 cellar: :any_skip_relocation, monterey:       "35431e80d2fa97986adc2058e59858a0f4336de483ac911696076152541ae9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1f1728f4c38ee32ea88c688f34ba51dc5c25c849214e4e629a2f70f8031ac4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (binbasename).write_env_script libexec"bin"basename, PROTO_LOOKUP_DIR: opt_prefix"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.protoshimsnode #{path}").strip
    assert_equal "hello", output
  end
end