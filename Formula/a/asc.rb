class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.44.0.tar.gz"
  sha256 "3a977c92f08a00c477dac1c280dd177fd8058869024da0017c4478e5ba32a005"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4568bd3101134309e02a218bc4ac3eb492e00d09010b78d7aebf7d71479f66e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac948739e99d151300273ecfa98589cb81941f9632756ad3454d154a14b43be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d3fcaeeba32a4ed33a0b996195ec5987e15daea1227b7e398902ff43d1504fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ea8b7c3e196c2e4e3a0062dd02c7aab41804a47b6aaa42e09b68f9207935865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fee6642e6b4be9e0026b79409195d480b291d4c3ce1bffcd5f74d654bbd80223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e87180a6c8724ee284fd7b4897a9dd7758e5375b201d9a39cecd42d46af286"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end