class CargoMake < Formula
  desc "Rust task runner and build tool"
  homepage "https:github.comsagieguraricargo-make"
  url "https:github.comsagieguraricargo-makearchiverefstags0.37.20.tar.gz"
  sha256 "a0482ab9397d3a96080ec8a147fc216bb3ec3b16569be876bc9537b8824a0b81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdcfa95c7db7e44570fcac7ecebc045f23cedc5dacc9155a0ccc6bc95029df05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44952937b8bc8ee6bf6b37c9e4fd3f16547d3eee740f1e2acf37d0fdb9b116bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4c3159703b1d9b0618ec4353eafc306c181819f7a6821e914f4c624664b6085"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddbe5fdacf04246155fbf79926870166b0f89d5f9f9a9c63fc74c7beffbdb50a"
    sha256 cellar: :any_skip_relocation, ventura:       "c00d92bf89e06c22fe49da3f00be4e5f8976bc473d5dab14583838a3d474877b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6996eb5cc0cb51e8ca210286c4a99d57a114e81bace8937a5017bbc6e985bbef"
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

    text = "it's working!"
    (testpath"Makefile.toml").write <<~EOF
      [tasks.is_working]
      command = "echo"
      args = ["#{text}"]
    EOF

    assert_match text, shell_output("cargo make is_working")
    assert_match text, shell_output("#{bin}cargo-make make is_working")
    assert_match text, shell_output("#{bin}makers is_working")
  end
end