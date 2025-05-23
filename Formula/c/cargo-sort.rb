class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https:github.comdevinr528cargo-sort"
  url "https:github.comDevinR528cargo-sortarchiverefstagsv2.0.0.tar.gz"
  sha256 "ba3e75c5bcb7dabad33a50bab42f22563718ab004c3b2a45e100d7f788a64f09"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdevinr528cargo-sort.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c530b1f7944978389f8c4e4cacdec7be8b5264f623fddecd99e622b986f95f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8308cccb2633a37a8b0900870af2bbd16d0a88cc49b757fca250c9628ff248e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f29db665498c065801da7fa5a55973586733f3e33bb8d403fef0d859a82dcce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "75e3b738511631dce10867539929896818e93a413529090de269bc073520ea06"
    sha256 cellar: :any_skip_relocation, ventura:       "ca0386bcf14f33996209d0f60058fe0d9bf4c580ccd22903dbf9445d1dd0cc66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96bde6df8a859a6b64abc5a8d62992bfbcf67bee079592ade91da05f465715d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0727b78ebee90a63944ca2cd02b33ad299f8caee97515168dd186950525a6d1b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}cargo-sort --version")

    mkdir "brewtest" do
      (testpath"brewtestCargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"

        [dependencies]
        c = "0.7.0"
        a = "0.5.0"
        b = "0.6.0"
      TOML

      output = shell_output("#{bin}cargo-sort --check 2>&1", 1)
      assert_match "Dependencies for brewtest are not sorted", output
    end
  end
end