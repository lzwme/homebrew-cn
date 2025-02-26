class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:www.greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.8.tar.gz"
  sha256 "90c37bc03399778b4a736f950734835b00d868e45811719230509b2a9c7f53a6"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0db74e5d1b922bac1ac029201ed080908cf98f9b334b59f8f792d48ad13f6ed3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0db74e5d1b922bac1ac029201ed080908cf98f9b334b59f8f792d48ad13f6ed3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0db74e5d1b922bac1ac029201ed080908cf98f9b334b59f8f792d48ad13f6ed3"
    sha256 cellar: :any_skip_relocation, sonoma:        "49779cba9c5f44b5cae07ca64ef27fdb387e120801fc8f8e9f2c33b2d1c8e850"
    sha256 cellar: :any_skip_relocation, ventura:       "49779cba9c5f44b5cae07ca64ef27fdb387e120801fc8f8e9f2c33b2d1c8e850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1201342ddf07add0fabbe79a2ba26d190d965f6c8482a9b25499bdf663de2f68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", "-tags=viper_bind_struct", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~YAML
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
    YAML

    output = shell_output("#{bin}greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end