class CargoPublicApi < Formula
  desc "List and diff the public API of Rust library crates"
  homepage "https:github.comcargo-public-apicargo-public-api"
  url "https:github.comcargo-public-apicargo-public-apiarchiverefstagsv0.43.0.tar.gz"
  sha256 "eccaf5003bd25180363ccf9a4d01bc392741f427be2d7a1f811f1e2805534324"
  license "MIT"
  head "https:github.comcargo-public-apicargo-public-api.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9142f35d99b13b5f29019a2e74d292c790ad3a7fe7069752826b62275a593a21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bff1d0622ebbeac32d11033708e18ec2f8ff08e57fcfca92b7284b7b6e408f52"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7b6987dd606de7d62136b02ee6d97528480970113f50a9ac735278e516e7c66"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e6325b675113f03117f63895c3b96c6f8a7b6dbdbff0ff2ed76341441d9ad3f"
    sha256 cellar: :any_skip_relocation, ventura:       "55276fede4b82357c7ac7c08867df27bf892173c05ae7e88ef66d6c712262126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88bcbd2aa87078551c74d5cdc06cbec7604ccd10f77ec39e58f9124ee65d0fa3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-public-api")

    generate_completions_from_executable(bin"cargo-public-api", "completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath"Cargo.toml").write <<~TOML
      [package]
      name = "test_package"
      version = "0.1.0"
      edition = "2021"
    TOML

    (testpath"srclib.rs").write <<~RUST
      pub fn public_function() -> i32 {
        42
      }
    RUST

    output = shell_output("#{bin}cargo-public-api diff")
    assert_match "Added items to the public API", output

    assert_match version.to_s, shell_output("#{bin}cargo-public-api --version")
  end
end