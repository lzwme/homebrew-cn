class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https:github.comsassmant-rec-rs"
  url "https:github.comsassmant-rec-rsarchiverefstagsv0.7.7.tar.gz"
  sha256 "ec3a94178a6488d302a3eeaf2f41ffca6828cc53457d4bcb43e03cfff8cb7bb3"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3491bb5fdecd77fac33ef5db295c18b461541be759848ba038c5c616df4f28ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd27edfbae62912daadc08512921d246d17bc4c57fb8c3d43d2a5d7a8f35ff75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a89d73c25e004836d9bb0a54a9499d671ed19d3d622b7dc7ba4514f2b51d5fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f112d22444d289b0b18d8e9ae0e50cb0f9d841ffd879a60335aa400308bbddbb"
    sha256 cellar: :any_skip_relocation, ventura:       "fb86b684f9585ee658f20dd84b9aa337f776a662dedf04263fa41ad4ca740814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575c1197d81fdb6afe187dc570af44a63ab488a28cdc432258708baccdce79cb"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: $DISPLAY variable not set and no value was provided explicitly", o
    end
  end
end