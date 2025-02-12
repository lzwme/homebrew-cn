class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https:github.comtaiki-ecargo-hack"
  url "https:github.comtaiki-ecargo-hackarchiverefstagsv0.6.35.tar.gz"
  sha256 "3a61da5f6d3620a64ceee2a3666817ffe0f4bfc9966699814e0b094fe10492a7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbee1b1a9085536153afbdc16cbee34f905da911dc7f653a410cfd7e4a46f729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab1b4833d1817b1831515f421efbf343a92b938cbd2994b8234d464821f61f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01e0dd4519dcb4144b5ef5106c028b4c0bfcf126eaf1bf3022a87c800caf5915"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a11af492f8d9d7732617511e6abee3cf16309717fbf26446d96e60664c7709c"
    sha256 cellar: :any_skip_relocation, ventura:       "3c5162d6cfd6de1489accf182a4e2c1e5a3ba55ef161a6724124c523d511394f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "466a51779dfe95f17346a5fd0d3eeb5c95f4ce6e88f2f2f5141195f14773bff4"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end