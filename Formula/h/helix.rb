class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https:helix-editor.com"
  url "https:github.comhelix-editorhelixreleasesdownload25.01helix-25.01-source.tar.xz"
  sha256 "922fba301e1a3d9b933a445ab2d306cffcd689d678ecd06f00870cfc874cffb8"
  license "MPL-2.0"
  head "https:github.comhelix-editorhelix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e40e9ec37277d8fdb510c1bcf617b680a6de9bbb0052961ba6dfc4808451546"
    sha256 cellar: :any,                 arm64_sonoma:  "ea5debc32010d5307e75180c8899d9142e457e9d7ee6564129362897709ea9ba"
    sha256 cellar: :any,                 arm64_ventura: "3836943634e9c46af86eb97578c4a0ae161928338b7d4a985b2ff6b057088ce0"
    sha256 cellar: :any,                 sonoma:        "1e7335cc84a01073b93854889a4e750f524afa97311e117abe3c2c56f03632c3"
    sha256 cellar: :any,                 ventura:       "1b0c6dfa35d4861bba9b7fa441fc1846cef07156d56072ad07ffd9af254d9a4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807a5afa9354263f8d3ff44e6c3ed7a823aceb97e6ea6a93d6055f3625a43d29"
  end

  depends_on "rust" => :build

  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtimegrammarssources"
    libexec.install "runtime"

    bash_completion.install "contribcompletionhx.bash" => "hx"
    fish_completion.install "contribcompletionhx.fish"
    zsh_completion.install "contribcompletionhx.zsh" => "_hx"
  end

  test do
    assert_match "post-modern text editor", shell_output("#{bin}hx --help")
    assert_match "✓", shell_output("#{bin}hx --health")
  end
end