class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https:github.comblacknonhwatch"
  url "https:github.comblacknonhwatcharchiverefstags0.3.16.tar.gz"
  sha256 "0026bf677dd5b6a0c0160e537c6638902917e26aec2265bd0144a6e0f6d78e56"
  license "MIT"
  head "https:github.comblacknonhwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47c451a2adae468d375277ab6aac3a4e39ac48c32903902da26c81df717cb58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02dfeac01590fb6a56a10d0e9ce2640984122f238abaf22fec4ac4984f4724ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "268c221940effc8717e8c0718165cab772fd3cf698b78c209dff5f9fa3ac1310"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2c09eeb5cb02424b86533ab837fda135db237043801f5b0cf7428b700c78e1"
    sha256 cellar: :any_skip_relocation, ventura:       "301222e51e8ced22afa28794fcc29747b37ec5debcd9d0a60edd08d27cfb6037"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef11e41bd6a353ad0abcdfbf18a2395043af04fa00507b702aeb01da532c37c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manhwatch.1"
    bash_completion.install "completionbashhwatch-completion.bash" => "hwatch"
    zsh_completion.install "completionzsh_hwatch"
    fish_completion.install "completionfishhwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}hwatch --version")
  end
end