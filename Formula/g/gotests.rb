class Gotests < Formula
  desc "Automatically generate Go test boilerplate from your source code"
  homepage "https://github.com/cweill/gotests"
  url "https://ghfast.top/https://github.com/cweill/gotests/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "6d7ce2754290c6247d3a4ee3a9ad521c84f4334e3905274c68ae232613f37953"
  license "Apache-2.0"
  head "https://github.com/cweill/gotests.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1483768ebe2632ad07c5df4e9429e6679e2fcb169204f902abae0a3e1c446f60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1483768ebe2632ad07c5df4e9429e6679e2fcb169204f902abae0a3e1c446f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1483768ebe2632ad07c5df4e9429e6679e2fcb169204f902abae0a3e1c446f60"
    sha256 cellar: :any_skip_relocation, sonoma:        "10baf54aba7e763522277d53b3ae70abe6b2df20501d97142ea8c7631676df3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cd7651074bae1c8505772f781e1db9021a516dcc06e95ece72b69a761479259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c64872bb9392eabca710417ce18dde058fce1030ea9d9aedf4ce15ca325353e3"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./gotests"
  end

  test do
    (testpath/"test.go").write <<~GO
      package main

      func add(x int, y int) int {
      	return x + y
      }
    GO
    expected = <<~EOS
      Generated Test_add
      package main

      import "testing"

      func Test_add(t *testing.T) {
      	type args struct {
      		x int
      		y int
      	}
      	tests := []struct {
      		name string
      		args args
      		want int
      	}{
      		// TODO: Add test cases.
      	}
      	for _, tt := range tests {
      		t.Run(tt.name, func(t *testing.T) {
      			if got := add(tt.args.x, tt.args.y); got != tt.want {
      				t.Errorf("add() = %v, want %v", got, tt.want)
      			}
      		})
      	}
      }
    EOS
    assert_equal expected, shell_output("#{bin}/gotests -all test.go")
  end
end