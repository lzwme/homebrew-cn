class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https:github.comtuna-f1shcyme"
  url "https:github.comtuna-f1shcymearchiverefstagsv2.1.1.tar.gz"
  sha256 "a4259f3a77a9b01dc1e8968a184113d47e353c332520f9384cd8d90f5d88b7bb"
  license "GPL-3.0-or-later"
  head "https:github.comtuna-f1shcyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89da05b7471adcf0f4ad726ffea17a281666663cfad2853878f6989c920f948d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107d2423c440b4899416d5ce4d2c42f48ac0c3a2189bb1dbbbcae8e8a4363de2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "883f637b63aecccc74079cae4da7a61fd60e40850b57619bdf217e2f90e7db73"
    sha256 cellar: :any_skip_relocation, sonoma:        "d19e2b4799a0527430047e682363eca91d311315701ebef717ae9d3609006dda"
    sha256 cellar: :any_skip_relocation, ventura:       "12d746e164f206f680f18d793de6d8cc5baa10e257f3ad0d6641c3317cbc2194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06dad774dd4a81a10274a0c5b27e38dd3724031ea8491ad6bc1e908c8f4cbb63"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doccyme.1"
    bash_completion.install "doccyme.bash"
    zsh_completion.install "doc_cyme"
    fish_completion.install "doccyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end