class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "043092eab4cab11dd551b5eab051065abd8bec4f0257d48da6f3768d0cbb8981"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62a408219cd54659057a600e40133c83516f1dc8bae5306feb43a97d70ae8ef3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a408219cd54659057a600e40133c83516f1dc8bae5306feb43a97d70ae8ef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62a408219cd54659057a600e40133c83516f1dc8bae5306feb43a97d70ae8ef3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f8bebe734e1573d39fbd1b371edda4779b36bcf2eb32f2b16b35100b94ab19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a7ee91643ff94a7f79da29b4ea75e9e12c7e77c6c2fbf4ea007e90624acf995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95e2d5f258dd772cf60e0269ae12627e7a535649d408206d56f25f7c2675160d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"), "./cmd/witr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    output = shell_output("#{bin}/witr --pid 99999999", 1)
    assert_match "No matching process or service found", output
  end
end