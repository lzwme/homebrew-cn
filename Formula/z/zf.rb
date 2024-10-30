class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https:github.comnatecraddockzf"
  url "https:github.comnatecraddockzfarchiverefstags0.10.1.tar.gz"
  sha256 "d1640134b002492d2ef823243bc49d96fe7e0780b0b2b45d29331caa9fbbbb27"
  license "MIT"
  head "https:github.comnatecraddockzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e83d6b000b2fb7f4514fcc6784499be3d90638f6cf499aeb49759bc79553f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79be676a3b29a77dd57a8954a27130ec20edc575018df0df1098da8aba980a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c118f618b1fa0014e943e676f2b11cec943c4bbf13fd3122be3a3ef15394e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "258e4735444e3cafe7431d41c7785415ff78935aca7cb1478355025bd641fc58"
    sha256 cellar: :any_skip_relocation, ventura:       "9c3e7a6e7d6796cbaca393b92cafd14b24b4eebca0778b66bfa16ac2ecac1c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "141a283ae3068d928127d004cd195ea23ecc647b5cb0c501c304adc9770f9945"
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe"

    bin.install "zig-outbinzf"
    man1.install "doczf.1"
    bash_completion.install "completezf"
    fish_completion.install "completezf.fish"
    zsh_completion.install "complete_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}zf -f zg", "take\off\every\nzig").chomp
  end
end