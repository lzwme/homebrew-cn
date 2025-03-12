class SigsumGo < Formula
  desc "Key transparency toolkit"
  homepage "https://sigsum.org"
  url "https://git.glasklar.is/sigsum/core/sigsum-go/-/archive/v0.11.0/sigsum-go-v0.11.0.tar.bz2"
  sha256 "787acbe02b221a4c62ff1ae6ef3d3239a3a408244d4d23cb14f66548c60d5faf"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9638155a9a7648a2e8afb5a63235ae1cfa12c44c2663f6721c5049c7b0bd93a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9638155a9a7648a2e8afb5a63235ae1cfa12c44c2663f6721c5049c7b0bd93a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9638155a9a7648a2e8afb5a63235ae1cfa12c44c2663f6721c5049c7b0bd93a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "28b6ea511a47f962f6b539023736dc398f3386013f38a7ee3f806ba323f9873a"
    sha256 cellar: :any_skip_relocation, ventura:       "28b6ea511a47f962f6b539023736dc398f3386013f38a7ee3f806ba323f9873a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b465fac2fb93c9e50fae5bd612e30de82bec9292fe4e74cd1622dea04952589"
  end

  depends_on "go" => :build

  def install
    %w[
      sigsum-key
      sigsum-monitor
      sigsum-submit
      sigsum-token
      sigsum-verify
      sigsum-witness
    ].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags: "-s -w"), "./cmd/#{cmd}"
    end
  end

  test do
    system bin/"sigsum-key", "gen", "-o", "key-file"
    pipe_output("#{bin}/sigsum-key sign -k key-file -o signature", (bin/"sigsum-key").read)
    pipe_output("#{bin}/sigsum-key verify -k key-file.pub -s signature", (bin/"sigsum-key").read)
  end
end