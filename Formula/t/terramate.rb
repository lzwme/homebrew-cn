class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.6.4.tar.gz"
  sha256 "381adc9040b5774f9c7ab5ce469bade9d28da9af40690d6812f759a6b028b3bd"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f22e829e1f21323aa4a82235e3b295bbf5c078d1005fdd3c1acd288b6d0800aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "086ff0d9bcf41224b78e0255e4fc3c3e81637c1042d7e2787ca9748eceb3a040"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cf0541677eacebbb6ed4f72e2a0ed20b35d2b1fb913c608c4f094e7727a555f"
    sha256 cellar: :any_skip_relocation, sonoma:         "9561f1700403a214a53e13b04835702d6fb66e4cbcb105ac16d6b0b025f24538"
    sha256 cellar: :any_skip_relocation, ventura:        "3cc9caf985547bd17774e0e8f0a63caacb8a3f9e38938b006680e74ca4bc665b"
    sha256 cellar: :any_skip_relocation, monterey:       "0aeeb90d4ea28e1e3a2848a3a1c5bb4991692169d34c02ed84b40e318f9a9b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327e063b77faf1fd6b7d112f8bf73e584ca010539c0f35e1d08cd0724ddde447"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end