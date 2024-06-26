class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.52.0.tar.gz"
  sha256 "2c4d79062c362ec2df289bfa8bb14487336f5bd6923ad0b1186f549d0adb3355"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86aa3864a0ba0e3ea612f1bfa67f8c9893035488dd54b8dffebfd03af30932a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "080ed910a2a2c04f262d8702024f4bb84aa7ecebe2c29c18588c1d9b5f3ba177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae41bdc2213a3ae2ae2f6eca4ece24d610eeb64ca797adf689d6845331fc018"
    sha256 cellar: :any_skip_relocation, sonoma:         "e49adfb83ed36cc1353c3d9613ddac07233a5224fe5e13620e404a5da95bd570"
    sha256 cellar: :any_skip_relocation, ventura:        "2da3eef9c22e37cf313fd92126a949d1fb548aac3b163f9ab226e37e1f1afd55"
    sha256 cellar: :any_skip_relocation, monterey:       "261e22c94edbcc3bae3b6513d651a0a56f1d5af39e74bac0e87475a74431e164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e1c69b80e5bdfabf7fd6ddc5e5577fd0947ec9dcf05cf13ac464b403189baaf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"k6", "completion")
  end

  test do
    (testpath"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}k6 version")
  end
end