class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://ghfast.top/https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.42.tar.gz"
  sha256 "04e2910a54506cea00831645dce3aa158fbd8b706b3fa59f3cc9cb72ab13c73d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "895644299292f661bd07f56f6fa92a3f83285fd56853fec3f243873e9891c924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcbf84a83a42cf2e21d613c0a02401e55ffe4f11086167910657b3ab82547a3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f84529da2854d27702f75afb0708efdbec112add43e91af1c5496e89b1b6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f141c8cc3908f0dc0b9aad134b996e94d08c6f3db641173d81c576b0fe13be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac3fab939f22d4fef640e5866db4cdfb0d963a664438aee5b7bbab8b0148e501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35ccf21c04fc6ebe90e99e657e9eb7a73b6c39fc7bbc6ab2e13380754e9a4a51"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end