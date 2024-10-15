class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https:github.comastral-shuv"
  url "https:github.comastral-shuvarchiverefstags0.4.21.tar.gz"
  sha256 "a8d60ede8c4b98ec1b341f06a680baff7ed13e0d8b5b6c8bda82730af8261ad1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comastral-shuv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb489196d79e9e63bf7882ae4ee223cae984df0c78ccc482b01d0df3920d82d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d881a2e79ea9c0f81a2320027ce74a3bbda43c5a4b0d196ef1e909576ecca7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b769a7cff2e5cec6c2898d6ebeb504825bcdaec550cabda4ecf0eb179c8cd51"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6963a69f88c3f4e185dcec237ca836038674ffc06b7db38b26dfc05ebc61a60"
    sha256 cellar: :any_skip_relocation, ventura:       "f308fee55626cb3a243df0d90512ca2460bfa759f0d8d14da12b92134111375b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92d7868ce09075418256f1c50720a3e8623e3fb0516e97d65f4f142086aa3b55"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesuv")
    generate_completions_from_executable(bin"uv", "generate-shell-completion")
    generate_completions_from_executable(bin"uvx", "--generate-shell-completion", base_name: "uvx")
  end

  test do
    (testpath"requirements.in").write <<~EOS
      requests
    EOS

    compiled = shell_output("#{bin}uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}uvx -q ruff@0.5.1 --version")
  end
end