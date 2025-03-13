class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https:keploy.io"
  url "https:github.comkeploykeployarchiverefstagsv2.4.11.tar.gz"
  sha256 "8a385288b1d9f7cc58f313efc23c136398e6ad6317101a8020bbaa7a4561c904"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963431288c1243f39bd7a9f2a544264f94f66632c1a515eab60cf1a101b69181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963431288c1243f39bd7a9f2a544264f94f66632c1a515eab60cf1a101b69181"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "963431288c1243f39bd7a9f2a544264f94f66632c1a515eab60cf1a101b69181"
    sha256 cellar: :any_skip_relocation, sonoma:        "1647effa10e67ff4403f5f0635a89567eaa5d2551f50a408e1eb5e811f8bce69"
    sha256 cellar: :any_skip_relocation, ventura:       "1647effa10e67ff4403f5f0635a89567eaa5d2551f50a408e1eb5e811f8bce69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e8f13778960807b49c45488afe8d6272df876930caca51a41eb43d9692a742f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath"keploy.yml").read

    output = shell_output("#{bin}keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}keploy --version")
  end
end