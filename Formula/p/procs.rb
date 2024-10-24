class Procs < Formula
  desc "Modern replacement for ps written in Rust"
  homepage "https:github.comdalanceprocs"
  url "https:github.comdalanceprocsarchiverefstagsv0.14.8.tar.gz"
  sha256 "b9cf37275bdf1c03786a035c1cd495a93cbf94406eb8c261825d1fd59dcfd61d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e407b6a7b0fbae16a9b4481e1be49706cd4142933b385bb2a31e046753f436f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a463a640b2d5f39cc3587dd32012f544fef8e0ba07ea4fd3e069f9bea6e179"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f645b5bc0a7bd2d55a16beef0c2d273ae4401010d35a1a91fcd1d041a4fa1f7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "230c209bb49369b9df04f16c3da5d81544c08ad4c47dda7d762e92c7efd7c2c9"
    sha256 cellar: :any_skip_relocation, ventura:       "93691438e20273414ae4b1517032e06d266005819a04df5dd1e0d98036a4c945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e15efc995578beb998375a4b0d2b66cee340068f42348bb479da7ecfe1a1c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin"procs", "--gen-completion", "bash"
    system bin"procs", "--gen-completion", "fish"
    system bin"procs", "--gen-completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end