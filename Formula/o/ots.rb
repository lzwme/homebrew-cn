class Ots < Formula
  desc "Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https:ots.sniptt.com"
  url "https:github.comsniptt-officialotsarchiverefstagsv0.3.1.tar.gz"
  sha256 "09f0b0d7ca44ec8414dbf631009df8c00f4750247c0f9ba25a32f0aa270e09cc"
  license "Apache-2.0"
  head "https:github.comsniptt-officialots.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c078703b06ed8d14bc91d73307528444a9fdbac4b30b36db115fd3936792da45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c078703b06ed8d14bc91d73307528444a9fdbac4b30b36db115fd3936792da45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c078703b06ed8d14bc91d73307528444a9fdbac4b30b36db115fd3936792da45"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e6c1a577e7d626108516f4fbb8c8019d8c48fb7306fe87ba215bb5c9731f95"
    sha256 cellar: :any_skip_relocation, ventura:       "89e6c1a577e7d626108516f4fbb8c8019d8c48fb7306fe87ba215bb5c9731f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1885731e0d68230f49366c27402326fdba9697f5ee4ced9ae0affda0127b1a88"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsniptt-officialotsbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"ots", "completion")
  end

  test do
    output = shell_output("#{bin}ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end