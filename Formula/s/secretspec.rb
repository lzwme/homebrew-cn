class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "66a2e3846ecb9eb80de46bfffbc7ecb67f316a230f7d6f41dd8959645c468123"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7fa2fc18a23ed56517ee87a53d41e99827d5e7a31fb4efa16942100cc05e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c9899855214e7009a2ceac53d8626c99c2378cc123cd5756b92948fc60fba23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35fca00dcd8f613913716449a6afac3a1e78c60c36bbb47f5a0c75cfc001be06"
    sha256 cellar: :any_skip_relocation, sonoma:        "259ec7baa867833172c7c288fe0c4cf0a8e85cbfcb6a1f22eca88f9042528841"
    sha256 cellar: :any,                 arm64_linux:   "7c48b8ded39fa311f812c6f4eabd025770d20c37e509f8e0501520d4326daab9"
    sha256 cellar: :any,                 x86_64_linux:  "4d95535ca11ef1411a8cd9599e5e77c9200af1ba133567ebdfaf6d85a4d80239"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end