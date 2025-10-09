class Bob < Formula
  desc "Version manager for neovim"
  homepage "https://github.com/MordechaiHadad/bob"
  url "https://ghfast.top/https://github.com/MordechaiHadad/bob/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "4c11df179e47b917c8cee9de47c2e30d2ac962aeed35899e309fad01de9b9ea0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5a94e68a545ffa4032ee8efce03f8ff39f31202e0b887951a145e856171f50c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d330fae0870ffa7824d0e6e778ebbe58e3cf24bf6bf61e5ac4deca8728b00f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5e9ad67a705a04d8c46c11981f26f3dbf19756ec55e5de296f82bb6642bf05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0595052dad62cb0d333b61d214b839d943a370ac6dbd78cd440c75952cfa5e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "858d35c273235644c9aab186a2976747271ff5e153c2b51903466a9d757f241f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2fc42c42076816228bf4aa3b9b574d7fe903336d5d5dbfd2d296e693a33a54f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"bob", "complete")
  end

  test do
    config_file = testpath/"config.json"
    config_file.write <<~JSON
      {
        "downloads_location": "#{testpath}/.local/share/bob",
        "installation_location": "#{testpath}/.local/share/bob/nvim-bin"
      }
    JSON

    ENV["BOB_CONFIG"] = config_file
    mkdir_p testpath/".local/share/bob"
    mkdir_p testpath/".local/share/nvim-bin"

    neovim_version = "v0.11.0"
    system bin/"bob", "install", neovim_version
    assert_match neovim_version, shell_output("#{bin}/bob list")
    assert_path_exists testpath/".local/share/bob"/neovim_version

    # failed to run `bob erase` in linux CI
    # upstream bug report, https://github.com/MordechaiHadad/bob/issues/287
    system bin/"bob", "erase" unless OS.linux?
  end
end