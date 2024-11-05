class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.1.tar.gz"
  sha256 "33e7b15bbbf008c29ea7f7fcf16435f3e64d1dafa461cac855599ea350d775e6"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95025c7c3e118b46e5daadefb7206f1317928082580cd603b462575174ef4df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95025c7c3e118b46e5daadefb7206f1317928082580cd603b462575174ef4df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e95025c7c3e118b46e5daadefb7206f1317928082580cd603b462575174ef4df"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e76b11bc5662e8b28bc5f8a1a222dc47e880d758ecc2ee02b3b8ca5c1d3b70a"
    sha256 cellar: :any_skip_relocation, ventura:       "0e76b11bc5662e8b28bc5f8a1a222dc47e880d758ecc2ee02b3b8ca5c1d3b70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f005c5caeb478244c8f4b8c9b3362e33d19ac6a42e5ea43a144d1a2f5cb26bfa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~EOS
      common:
        pg_bin_path: "usrlibpostgresql16bin"
        tmp_dir: "tmp"

      storage:
        s3:
          endpoint: "http:playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    EOS

    output = shell_output("#{bin}greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end