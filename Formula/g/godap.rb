class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https:github.comMacmodgodap"
  url "https:github.comMacmodgodaparchiverefstagsv2.7.0.tar.gz"
  sha256 "d5707d3ec92cdd758d674b0a2f3e52dc796d1385df67913adcac1f8cb30198eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4479e5484f12e74de54ce7f9d2b5aa5f3dff756402c895c5efc4e7e36427a86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53adfde5df4ff43ae7145e791b52adff0358edbabd8a2d339cc480a3a1c97f8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f66c8b74930ab7b3ddb99b15cb9aad5761c92f6a56d46fda48ed79bf9c5197"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7312d830b9ecc7ba0691c15fdb1e10824eb0fe2d92cc61d0281df864724dedd"
    sha256 cellar: :any_skip_relocation, ventura:        "6f4200c55c10d68f0e68c32cee9b9351cc57ddcbbb4c0cf8c3581872e4262e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "61dd4622bc18ae7bc21075938bb34bf8ed8ba7c052f9443a332db465db07c972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caeb08a1284cb3a063c7047e05b7bd9d52ee6ec736c68dc255c5993d06860a40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: io timeout", output

    assert_match version.to_s, shell_output("#{bin}godap version")
  end
end